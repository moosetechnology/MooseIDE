"
I show an instance side settings for the current co usage map
"
Class {
	#name : #MiCoUsageMapInstanceSettingsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'generalSettings',
		'blockSettings',
		'coUsageMap',
		'properties'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #layout }
MiCoUsageMapInstanceSettingsPresenter class >> defaultLayout [
	^ SpTabLayout new
		add: (SpScrollableLayout with: #generalSettings) label: 'General Settings';
		add: (SpScrollableLayout with: #blockSettings) label: 'Block Settings';
		yourself
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> childrenBlockCompiled [
	^ self 
		compiledBlock: self childrenBlockText 
		onError: self settingsClass defaultChildrenBlockText
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> childrenBlockText [
	^ properties at: #childrenBlockText ifAbsentPut: [ self settingsClass childrenBlockText ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> childrenBlockText: aString [
	properties at: #childrenBlockText put: aString.
	self coUsageMap updateChildren.
]

{ #category : #accessing }
MiCoUsageMapInstanceSettingsPresenter >> coUsageMap [
	^ coUsageMap
]

{ #category : #accessing }
MiCoUsageMapInstanceSettingsPresenter >> coUsageMap: aMiCoUsageMapVisualization [ 
	coUsageMap := aMiCoUsageMapVisualization
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> compiledBlock: aString onError: defaultString [
	^ self settingsClass compiledBlock: aString onError: defaultString
]

{ #category : #initialization }
MiCoUsageMapInstanceSettingsPresenter >> initializePresenters [
	properties := Dictionary new.
	blockSettings := self instantiate: MiCoUsageMapBlockSettingsPresenter.
	blockSettings settings: self.
	generalSettings := self instantiate: MiCoUsageMapGeneralSettingsPresenter.
	generalSettings settings: self
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> innerBoxHeight [
	^ properties 
		at: #innerBoxHeight 
		ifAbsentPut: [ self settingsClass innerBoxHeight ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> innerBoxHeight: anObject [
	properties at: #innerBoxHeight put: anObject.
	coUsageMap updateInnerBoxSize
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> innerBoxRange [
	^ properties 
		at: #innerBoxRange 
		ifAbsentPut: [ self settingsClass innerBoxRange ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> innerBoxRange: anInterval [
	properties at: #innerBoxRange put: anInterval.
	coUsageMap updateInnerBoxSize
	
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> innerBoxScaleType [
	^ properties 
		at: #innerBoxScaleType 
		ifAbsentPut: [ self settingsClass innerBoxScaleType ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> innerBoxScaleType: aString [
	properties at: #innerBoxScaleType put: aString.
	coUsageMap updateInnerBoxSize
	
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> innerBoxSortBlockCompiled [
	^ self 
		compiledBlock: self innerBoxSortBlockText 
		onError: self settingsClass defaultInnerBoxSortBlockText
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> innerBoxSortBlockText [
	^ properties at: #innerBoxSortBlockText ifAbsentPut: [ self settingsClass innerBoxSortBlockText ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> innerBoxSortBlockText: aString [
	properties at: #innerBoxSortBlockText put: aString.
	self coUsageMap updateShapeLayout.
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> outerBoxSortBlockCompiled [
	^ self 
		compiledBlock: self outerBoxSortBlockText 
		onError: self settingsClass defaultOuterBoxSortBlockText
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> outerBoxSortBlockText [
	^ properties at: #outerBoxSortBlockText ifAbsentPut: [ self settingsClass outerBoxSortBlockText ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> outerBoxSortBlockText: aString [
	properties at: #outerBoxSortBlockText put: aString.
	self coUsageMap updateShapeLayout.
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> resetText [
	properties
		removeKey: #childrenBlockText;
		removeKey: #outerBoxSortBlockText;
		removeKey: #innerBoxSortBlockText
]

{ #category : #accessing }
MiCoUsageMapInstanceSettingsPresenter >> scaleTypes [
	^ self settingsClass scaleTypes
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> settingsClass [
	^ MiCoUsageMapSettings
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> threshold75PercentGroup [
	^ properties 
		at: #threshold75PercentGroup 
		ifAbsentPut: [ self settingsClass threshold75PercentGroup ].
]

{ #category : #properties }
MiCoUsageMapInstanceSettingsPresenter >> threshold75PercentGroup: anObject [
	properties 
		at: #threshold75PercentGroup 
		put: anObject.
	coUsageMap threshold75: anObject.
]
