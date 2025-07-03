Class {
	#name : #MiModelsSettingsMemento,
	#superclass : #Object,
	#instVars : [
		'shouldCreateCache',
		'filterStubs',
		'modelImportIsAutomatic'
	],
	#category : #'MooseIDE-Meta-Settings'
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

{ #category : #accessing }
MiModelsSettingsMemento >> shouldCreateCache [

	^ shouldCreateCache
]

{ #category : #accessing }
MiModelsSettingsMemento >> shouldCreateCache: aBoolean [

	shouldCreateCache := aBoolean
]
