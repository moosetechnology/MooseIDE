"
I show an instance side settings for the current co usage map
"
Class {
	#name : #MiCoUsageMapInstanceSettingsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'blockSettings',
		'threshold',
		'innerBoxHeight',
		'innerBoxWidthScale',
		'rangeInnerWidth',
		'coUsageMap',
		'properties'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #layout }
MiCoUsageMapInstanceSettingsPresenter class >> defaultLayout [
	| blockSettings generalSettings |
	blockSettings := SpScrollableLayout with:
		(SpBoxLayout newTopToBottom
			add: #blockSettings;
			yourself).
	generalSettings := SpScrollableLayout with:
		(SpBoxLayout newTopToBottom
			spacing: 3;
			add: 'Threshold percent per group' asPresenter expand: false;
			add: #threshold expand: false;
			add: 'Inner box height' asPresenter expand: false;
			add: #innerBoxHeight expand: false;
			add: 'Inner box width scale' asPresenter expand: false;
			add: #innerBoxWidthScale expand: false;
			add: 'Range for inner boxes' asPresenter expand: false;
			add: #rangeInnerWidth expand: false;
			yourself
			).
	^ SpTabLayout new
		add: generalSettings label: 'General Settings';
		add: blockSettings label: 'Block Settings';
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
MiCoUsageMapInstanceSettingsPresenter >> connectPresenters [
	innerBoxWidthScale items: #(linear symlog).
]

{ #category : #initialization }
MiCoUsageMapInstanceSettingsPresenter >> initializePresenters [
	properties := Dictionary new.
	blockSettings := self instantiate: MiCoUsageMapBlockSettingsPresenter.
	blockSettings settings: self.
	threshold := self instantiate: MiCoSliderPresenter.
	innerBoxHeight := self instantiate: MiCoSliderPresenter.
	innerBoxWidthScale := self newDropList.
	rangeInnerWidth := self instantiate: MiCoDualSliderPresenter.
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
MiCoUsageMapInstanceSettingsPresenter >> settingsClass [
	^ MiCoUsageMapSettings
]
