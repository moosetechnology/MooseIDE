Class {
	#name : 'MiModelsSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
	#instVars : [
		'shouldCreateCache',
		'filterStubs',
		'modelImportIsAutomatic'
	],
	#category : 'MooseIDE-Meta-ModelsBrowser',
	#package : 'MooseIDE-Meta',
	#tag : 'ModelsBrowser'
}

{ #category : 'accessing' }
MiModelsSettingsConfiguration >> filterStubs [

	^ filterStubs
]

{ #category : 'accessing' }
MiModelsSettingsConfiguration >> filterStubs: aBoolean [

	filterStubs := aBoolean
]

{ #category : 'accessing' }
MiModelsSettingsConfiguration >> modelImportIsAutomatic [

	^ modelImportIsAutomatic
]

{ #category : 'accessing' }
MiModelsSettingsConfiguration >> modelImportIsAutomatic: aBoolean [

	modelImportIsAutomatic := aBoolean
]

{ #category : 'as yet unclassified' }
MiModelsSettingsConfiguration >> settingsPresenters [

	^ super settingsPresenters
		  add: ((MiBooleanSettingPresenter on: self)
				   label: 'Import withCache?';
				   help:
					   'Caching entities in the model may improve some functionalities but takes time on import';
				   state: shouldCreateCache;
				   whenStateChangedDo: [ :boolean |
					   self shouldCreateCache: boolean ];
				   yourself);
		  add: ((MiBooleanSettingPresenter on: self)
				   label: 'Filter out stubs?';
				   help:
					   'When propagating the model should it filter out the stub entities or pass them along';
				   state: filterStubs;
				   whenStateChangedDo: [ :boolean | self filterStubs: boolean ];
				   yourself);
		  add: ((MiBooleanSettingPresenter on: self)
				   label: 'Automatically import drag&drop files?';
				   help:
					   'When drag & drop model from file should it be automatically imported if possible or should it just configure the import dialog';
				   state: modelImportIsAutomatic;
				   whenStateChangedDo: [ :boolean |
					   self modelImportIsAutomatic: boolean ];
				   yourself);
		  yourself
]

{ #category : 'accessing' }
MiModelsSettingsConfiguration >> shouldCreateCache [

	^ shouldCreateCache
]

{ #category : 'accessing' }
MiModelsSettingsConfiguration >> shouldCreateCache: aBoolean [

	shouldCreateCache := aBoolean
]
