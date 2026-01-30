package com.boot;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
//		registry.addResourceHandler("/upload/**").addResourceLocations("file:///C:/develop/upload/")
		registry.addResourceHandler("/recipe/thumbnail/**")
				.addResourceLocations("file:///C:/matflix_upload/recipe/thumbnail/").setCachePeriod(3600)
				.resourceChain(true);

		registry.addResourceHandler("/recipe/step/**").addResourceLocations("file:///C:/matflix_upload/recipe/step/")
				.setCachePeriod(3600).resourceChain(true);

		registry.addResourceHandler("/review/**").addResourceLocations("file:///C:/matflix_upload/review/")
				.setCachePeriod(3600).resourceChain(true);

		registry.addResourceHandler("/profile/**").addResourceLocations("file:///C:/matflix_upload/profile/")
				.setCachePeriod(3600).resourceChain(true);
	}
}