'use strict'
const { spawnSync } = require('child_process')
const path = require('path')
const fs = require('fs')
const os = require('os')

const { program, Option } = require('commander')
const YAML = require('yaml')
const mustache = require('mustache')
const chalk = require('chalk')
const console = require('console')

class Log {
  title() {
    let separator = '# ' + '-'.repeat(60) + '\n#'
    separator = chalk.green(separator)

    let message = [...arguments].join(' ')
    message = chalk.greenBright(message)

    let output = chalk.bold(`\n${separator} ${message}`)
    console.log(output)
  }

  error() {
    let message = [...arguments].join(' ')
    message = chalk.bold(chalk.red(message))

    console.error(message)
  }

  info(topic) {
    topic = chalk.bold(chalk.yellow(topic))

    let args = [...arguments]
    args.shift()
    let message = args.join(' ')

    console.log(`${topic} ${message}`)
  }
}
let log = new Log()

function getProjectRoot() {
  let getRootCommand = spawnSync('git', ['rev-parse', '--show-toplevel'])
  if (getRootCommand.status != 0) {
    let error = getRootCommand.stderr
    log.error(`Unable to get project root:\n ${error}`)
    process.exit(1)
  }
  return getRootCommand.stdout.toString().trim()
}

function getOptions(availableInstances) {
  const instanceOption = new Option('-i, --instance <type>', 'instance of workplace')
  instanceOption.choices(availableInstances)
  instanceOption.mandatory = true

  program
    .addOption(instanceOption)
    .parse()
  return program.opts()
}

function parseConfigsYml() {
  // Read config file.
  const configPath = path.join(__dirname, 'configs.yml')
  let file
  try {
    file = fs.readFileSync(configPath, 'utf8')
  } catch(error) {
    log.error('Unable read config file:')
    log.error(error)
    process.exit(1)
  }

  // Replace @ -> project root.
  file = file.replaceAll('@', getProjectRoot())

  // Parse yml.
  try {
    let data = YAML.parse(file, {merge: true})
    return data
  } catch(error) {
    log.error('Unable to parse configs.yaml')
    log.error(error)
    process.exit(1)
  }
}


function objectEmpty(object) {
  if (typeof object !== 'object') {
    log.error('First argument must be an object')
    throw {error: 'Is not an object', object}
  }

  return Object.keys(object).length === 0
}

function makeLinks(links) {
  // Check empty links.
  if (objectEmpty(links)) {
    log.info('Nothing to do')
    return
  }

  for (let [_, files] of Object.entries(links)) {
    let target = files[0]
    let symlink = files[1]

    // Get command string.
    let commandString
    if (fs.statSync(target).isDirectory()) {
      // Create directory and make all target links.
      commandString = `mkdir -p ${symlink} && ln -sf ${target}/* -t ${symlink}`
    } else {
      // Create base directory and make target link.
      commandString = `mkdir -p $(dirname ${symlink}) && ln -sf ${target} ${symlink}`
    }

    // Perform command.
    let command = spawnSync(commandString, [], {shell: true})

    // Check errors.
    if (command.status != 0) {
      let error = command.stderr.toString().trim()
      log.error(`Error creation ${symlink}:\n ${error}`)
    } else {
      log.info('Created:', symlink)
    }
  }
}

function makeCommands(commands) {
  // Check empty commands.
  if (objectEmpty(commands)) {
    log.info('Nothing to do')
    return
  }

  for (let [_, data] of Object.entries(commands)) {
    // Render process string.
    let processString
    try {
      processString = mustache.render(data.command, data)
    } catch (error) {
      log.error('Unable render command')
      log.error(error)
      continue
    }

    // Execute process.
    let process = spawnSync(processString, [], {shell: true})

    // Log.
    if (process.status != 0) {
      let error = process.stderr.toString().trim()
      log.error(`Error command:\n ${processString}\n ${error}`)
    } else {
      log.info('Executed:', processString)
    }
  }
}

function makeTemplates(templates) {
  // Check empty templates.
  if (objectEmpty(templates)) {
    log.info('Nothing to do')
    return
  }

  // Get default data
  let defaultData = {
    user: os.userInfo().username,
    homedir: os.homedir()
  }

  // Make templates
  for (let [_, templateData] of Object.entries(templates)) {
    let inputPath = templateData.instance.input
    let outputPath = templateData.instance.output
    outputPath = outputPath.replace('~', os.homedir())
    let data = Object.assign(defaultData, templateData.data)

    try {
      let template = fs.readFileSync(inputPath, 'utf8').toString()
      let renderedConfig = mustache.render(template, data)
      fs.writeFileSync(outputPath, renderedConfig)
    } catch (error) {
      log.error('Unable render config')
      log.error(error)
      continue
    }

    log.info('Rendered:', templateData.instance.output)
  }
}

// Get all configs data.
const configsData = parseConfigsYml()
const availableInstances = Object.keys(configsData).filter(key => key[0] != '.')

// Get workplace instance configs.
const options = getOptions(availableInstances)
let prettyOptions = YAML.stringify(options).slice(0,-1)
log.info('Options:\n', prettyOptions)

// Get process data.
const currentConfig = configsData[options.instance]

let links = currentConfig.links ? currentConfig.links : {}
let commands = currentConfig.commands ? currentConfig.commands : {}
let templates = currentConfig.templates ? currentConfig.templates : {}

// Process.
log.title('Make symlinks:')
makeLinks(links)
log.title('Make commands:')
makeCommands(commands)
log.title('Make templates:')
makeTemplates(templates)
