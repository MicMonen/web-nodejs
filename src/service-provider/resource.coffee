
import CoffeescriptAsset 	from '../middleware/coffeescript-asset'
import StylusAsset 			from '../middleware/stylus-asset'
import ServiceProvider 		from '../core/service-provider'
import views 				from 'koa-views'

export default class Core extends ServiceProvider

	boot:->

		@bootViewRenderer()
		@bootAssets()

	bootViewRenderer:->

		koa = @make 'koa'

		koa.use views './resources/views/', {
			extension: 'pug'
		}

	bootAssets:->

		config = @make 'config'
		router = @make 'router'
		debug  = config.app.debug
		assets = new Object

		for route, resource of config.assets.scripts
			assets[route] = new CoffeescriptAsset route, resource, debug

		for route, resource of config.assets.styles
			assets[route] = new StylusAsset route, resource, debug

		for route, asset of assets
			handle = asset.handle.bind asset
			router.get route, handle
			asset.setup()
