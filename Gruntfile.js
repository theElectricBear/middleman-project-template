module.exports = function (grunt) {

	require('time-grunt')(grunt);

	// Load Grunt modules
	require('load-grunt-tasks')(grunt);

	grunt.initConfig({

		pkg: grunt.file.readJSON('package.json'),

		clean: ["time-order-forms", "people", "entertainment-weekly"]

	});


	// Set Grunt tasks

	grunt.registerTask('preview', ['']);

	grunt.registerTask('build', ['clean']);

}
