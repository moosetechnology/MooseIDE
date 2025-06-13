Class {
	#name : #MiModelsBrowserSettingsManager,
	#superclass : #MiAbstractSettingsManager,
	#instVars : [
		'shouldCreateCache',
		'filterStubs',
		'modelImportIsAutomatic'
	],
	#category : #'MooseIDE-Meta-ModelsBrowser'
}

{ #category : #accessing }
MiModelsBrowserSettingsManager >> filterStubs [

	^ filterStubs
]

{ #category : #accessing }
MiModelsBrowserSettingsManager >> filterStubs: aBoolean [

	filterStubs := aBoolean
]

{ #category : #initialization }
MiModelsBrowserSettingsManager >> initializeSettingsBuilders [

	settingsBuilders
		add: (MiCreateCacheSettingBuilder on: self);
		add: (MiAutomaticModelsImportSettingBuilder on: self);
		add: (MiFilterStubsSettingBuilder on: self)
]

{ #category : #accessing }
MiModelsBrowserSettingsManager >> modelImportIsAutomatic [

	^ modelImportIsAutomatic
]

{ #category : #accessing }
MiModelsBrowserSettingsManager >> modelImportIsAutomatic: aBoolean [

	modelImportIsAutomatic := aBoolean
]

{ #category : #accessing }
MiModelsBrowserSettingsManager >> shouldCreateCache [

	^ shouldCreateCache
]

{ #category : #accessing }
MiModelsBrowserSettingsManager >> shouldCreateCache: aBoolean [

	shouldCreateCache := aBoolean
]
