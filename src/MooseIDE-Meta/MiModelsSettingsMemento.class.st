Class {
	#name : #MiModelsSettingsMemento,
	#superclass : #MiMemento,
	#instVars : [
		'shouldCreateCache',
		'filterStubs',
		'modelImportIsAutomatic'
	],
	#category : #'MooseIDE-Meta-ModelsBrowser'
}

{ #category : #accessing }
MiModelsSettingsMemento >> filterStubs [

	^ filterStubs
]

{ #category : #accessing }
MiModelsSettingsMemento >> filterStubs: aBoolean [

	filterStubs := aBoolean
]

{ #category : #accessing }
MiModelsSettingsMemento >> modelImportIsAutomatic [

	^ modelImportIsAutomatic
]

{ #category : #accessing }
MiModelsSettingsMemento >> modelImportIsAutomatic: aBoolean [

	modelImportIsAutomatic := aBoolean
]

{ #category : #'as yet unclassified' }
MiModelsSettingsMemento >> settingsPresenters [

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

{ #category : #accessing }
MiModelsSettingsMemento >> shouldCreateCache [

	^ shouldCreateCache
]

{ #category : #accessing }
MiModelsSettingsMemento >> shouldCreateCache: aBoolean [

	shouldCreateCache := aBoolean
]
