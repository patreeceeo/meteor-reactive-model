Package.describe({
  summary: "An MVC model class for Meteor."
});

Package.on_use(function (api, where) {
  api.use('coffeescript');
  api.add_files('lib/reactive_model.coffee', ['client', 'server']);
  api.export('ReactiveModel');
});

Package.on_test(function (api) {
  api.use([
          'reactive-model',
          'tinytest',
          'test-helpers',
          'coffeescript',
          'mongo-livedata'
  ]);

  api.add_files('tests/reactive_model_tests.coffee', ['client', 'server']);
});
