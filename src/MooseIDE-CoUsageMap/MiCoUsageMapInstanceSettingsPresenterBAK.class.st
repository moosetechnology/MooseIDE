Class {
	#name : #MiCoUsageMapInstanceSettingsPresenterBAK,
	#superclass : #SpPresenter,
	#instVars : [
		'generalSettings',
		'blockSettings',
		'properties',
		'mapVisualization'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #layout }
MiCoUsageMapInstanceSettingsPresenterBAK class >> defaultLayout [
	^ SpTabLayout new
		add: (SpScrollableLayout with: #generalSettings) label: 'General Settings';
		add: (SpScrollableLayout with: #blockSettings) label: 'Block Settings';
		yourself
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> childrenBlockCompiled [
	^ self 
		compiledBlock: self childrenBlockText 
		onError: self settingsClass defaultChildrenBlockText
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> childrenBlockText [
	^ properties at: #childrenBlockText ifAbsentPut: [ self settingsClass childrenBlockText ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> childrenBlockText: aString [
	properties at: #childrenBlockText put: aString.
	self mapVisualization updateChildren.
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> compiledBlock: aString onError: defaultString [
	^ self settingsClass compiledBlock: aString onError: defaultString
]

{ #category : #initialization }
MiCoUsageMapInstanceSettingsPresenterBAK >> initializePresenters [
	properties := Dictionary new.
	blockSettings := self instantiate: MiCoUsageMapBlockSettingsPresenter.
	blockSettings settings: self.
	generalSettings := self instantiate: MiCoUsageMapGeneralSettingsPresenter.
	generalSettings settings: self
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> innerBoxHeight [
	^ properties 
		at: #innerBoxHeight 
		ifAbsentPut: [ self settingsClass innerBoxHeight ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> innerBoxHeight: anObject [
	properties at: #innerBoxHeight put: anObject.
	mapVisualization updateInnerBoxSize
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> innerBoxRange [
	^ properties 
		at: #innerBoxRange 
		ifAbsentPut: [ self settingsClass innerBoxRange ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> innerBoxRange: anInterval [
	properties at: #innerBoxRange put: anInterval.
	mapVisualization updateInnerBoxSize
	
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> innerBoxScaleType [
	^ properties 
		at: #innerBoxScaleType 
		ifAbsentPut: [ self settingsClass innerBoxScaleType ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> innerBoxScaleType: aString [
	properties at: #innerBoxScaleType put: aString.
	mapVisualization updateInnerBoxSize
	
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> innerBoxSortBlockCompiled [
	^ self 
		compiledBlock: self innerBoxSortBlockText 
		onError: self settingsClass defaultInnerBoxSortBlockText
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> innerBoxSortBlockText [
	^ properties at: #innerBoxSortBlockText ifAbsentPut: [ self settingsClass innerBoxSortBlockText ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> innerBoxSortBlockText: aString [
	properties at: #innerBoxSortBlockText put: aString.
	self mapVisualization updateShapeLayout.
]

{ #category : #accessing }
MiCoUsageMapInstanceSettingsPresenterBAK >> mapVisualization [
	^ mapVisualization
]

{ #category : #accessing }
MiCoUsageMapInstanceSettingsPresenterBAK >> mapVisualization: aMiCoUsageMapVisualization [ 
	mapVisualization := aMiCoUsageMapVisualization
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> outerBoxSortBlockCompiled [
	^ self 
		compiledBlock: self outerBoxSortBlockText 
		onError: self settingsClass defaultOuterBoxSortBlockText
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> outerBoxSortBlockText [
	^ properties at: #outerBoxSortBlockText ifAbsentPut: [ self settingsClass outerBoxSortBlockText ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> outerBoxSortBlockText: aString [
	properties at: #outerBoxSortBlockText put: aString.
	self mapVisualization updateShapeLayout.
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> resetText [
	properties
		removeKey: #childrenBlockText;
		removeKey: #outerBoxSortBlockText;
		removeKey: #innerBoxSortBlockText
]

{ #category : #accessing }
MiCoUsageMapInstanceSettingsPresenterBAK >> scaleTypes [
	^ self settingsClass scaleTypes
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> settingsClass [
	^ MiCoUsageMapSettings
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> threshold75PercentGroup [
	^ properties 
		at: #threshold75PercentGroup 
		ifAbsentPut: [ self settingsClass threshold75PercentGroup ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenterBAK >> threshold75PercentGroup: anObject [
	properties 
		at: #threshold75PercentGroup 
		put: anObject.
	mapVisualization threshold75: anObject.
]
