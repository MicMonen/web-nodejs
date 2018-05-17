
import Middleware from './middleware'

export default class ServiceProvider

	constructor:(@container)->
		# define alias helper functions.
		@singleton 	= @container.singleton.bind @container
		@instance 	= @container.instance.bind @container
		@make 		= @container.make.bind @container

	register:->
	boot:->



	resolveMiddleware:(instance)->
		if typeof instance is 'string'
			instance = @container.make instance

		if instance instanceof Middleware
			return instance.middleware.bind instance

		return instance

	# ------------------------------------------
	# Env helpers

	when:(environment, callback = null)->

		if environment is @container.config.app.env
			if callback
				await callback.call @

			return true

		return false

	# ------------------------------------------
	# Middleware helpers

	middleware:(middleware)->
		middleware 	= @resolveMiddleware middleware
		router 		= @container.make 'router'

		router.use middleware()

	route:(method, path, action)->
		middleware 	= @resolveMiddleware action
		router 		= @container.make 'router'
		validator 	= @container.make 'validator'

		router[method].call router, path, middleware validator

	# ------------------------------------------
	# Route helpers

	get:(path, action)->
		return @route 'get', path, action

	post:(path, action)->
		return @route 'post', path, action

	put:(path, action)->
		return @route 'put', path, action

	delete:(path, action)->
		return @route 'delete', path, action

	# ------------------------------------------
	# Validation helpers

	# rules:(rules)->
	# 	set = @container.make 'rule-set'
	# 	Object.assign set, rules

	# ------------------------------------------
	# Database helpers

	migrate: ->
		database = @container.make 'database'
		await database.migrate.latest()

	seed: ->
		database = @container.make 'database'
		await knex.seed.run()

	# ------------------------------------------
	# Cronjob helpers

	schedule: (expression, task) ->
		cronjob = @container.make 'cronjob'
		cronjob.addTask expression, task
