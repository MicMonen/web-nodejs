
import Router 			from 'koa-router'
import Koa 				from 'koa'
import Joi 				from 'joi'
import Validator 		from '../core/validator'
import ServiceProvider 	from '../core/service-provider'
import HttpKernel 		from '../kernel/http'

export default class Core extends ServiceProvider

	register: ->

		@singleton 'validator', ->
			return new Validator Joi

		@singleton 'router', ->
			return new Router

		@singleton 'koa', ->
			return new Koa

		@singleton 'kernel.http', ->
			return new HttpKernel @koa, @router, @config.http.port
