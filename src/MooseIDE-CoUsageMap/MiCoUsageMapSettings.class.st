"
I am a singleton, I store global values for settings used by CoUsageMapBuilder
"
Class {
	#name : 'MiCoUsageMapSettings',
	#superclass : 'Object',
	#instVars : [
		'properties'
	],
	#category : 'MooseIDE-CoUsageMap-Settings',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Settings'
}

{ #category : 'settings' }
MiCoUsageMapSettings >> browsingBlockSettings: aBuilder [
	<systemsettings>
	(aBuilder group: #ShowBlockSettings)
		target: self;
		parent: #CoUsageMap;
		order: 101;
		label: 'Blocks settings';
		description: 'Receives 2 outer nodes, returns if it should swap nodes';
		dialog: [ PluggableButtonMorph
			on: self
			getState: nil
			action: #openBlocksSettings
			label: #buttonSettingLabel ]
		

]

{ #category : 'settings' }
MiCoUsageMapSettings >> browsingSettingInnerBoxRange: aBuilder [
	<systemsettings>
	
	(aBuilder miDualRange: #innerBoxRange)
		parent: #CoUsageMap;
		target: self;
		order: 4;
		label: 'Range for inner boxes';
		description: 'Use this to change the minimun and maximun size of the inner boxes';
		default: self defaultInnerBoxRange;
		range: (5 to: 100)

]

{ #category : 'settings' }
MiCoUsageMapSettings >> browsingSettingInnerScale: aBuilder [
	<systemsettings>
	(aBuilder pickOne: #innerBoxScaleType)
		parent: #CoUsageMap;
		domainValues: self scaleTypes;
		target: self;
		order: 3;
		label: 'Inner box width scale';
		description: 'Choose between different types of scales';
		default: self defaultInnerBoxScaleType
]

{ #category : 'settings' }
MiCoUsageMapSettings >> browsingSettingInnerSize: aBuilder [
	<systemsettings>
	(aBuilder miRange: #innerBoxHeight)
		parent: #CoUsageMap;
		target: self;
		order: 1;
		label: 'Inner box height';
		description: 'Will change the height of the inner box for co usage map visualization';
		default: self defaultInnerBoxHeight;
		range: (2 to: 50)

]

{ #category : 'settings' }
MiCoUsageMapSettings >> browsingSettingThreshold: aBuilder [
	<systemsettings>
	(aBuilder miRange: #threshold75PercentGroup)
		parent: #CoUsageMap;
		target: self;
		order: 0;
		label: 'Threshold percent per group';
		description: 'This threshold is used by automatic color methods in the CoUsageMapBrowser.
When the container has several attributes of different colors, the color is chosen from the group that exceeds the threshold in relation to the size of the attributes.';
		default: self defaultThreshold75;
		range: (10 to: 100)

]

{ #category : 'settings' }
MiCoUsageMapSettings >> browsingSettings02On: aBuilder [

	<systemsettings>
	(aBuilder group: #CoUsageMap)
		parent: #moose;
		label: 'Co Usage Map';
		description: 'Alls settings concerned with co usage map browser';
		order: 10
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> buttonSettingLabel [
	^ 'Blocks Settings'
		

]

{ #category : 'accessing - computed' }
MiCoUsageMapSettings >> childrenBlockCompiled [
	^ self compiledBlock: self childrenBlockText onError: self defaultChildrenBlockText
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> childrenBlockText [
	^ self propertiesMap at: #childrenBlockText ifAbsent: [ self defaultChildrenBlockText ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> childrenBlockText: aString [
	self propertiesMap at: #childrenBlockText put: aString
]

{ #category : 'accessing - computed' }
MiCoUsageMapSettings >> compiledBlock: aString onError: defaultString [
	| compiler |
	compiler := Smalltalk compiler.
	^ [ compiler evaluate: aString ]
	on: Error
	do: [ :ex | compiler evaluate: defaultString ]
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultChildrenBlockText [

	^ '"This code is for entity method, but you can change it
You should return all the inner entities even with duplicates"
[ :entity |
	entity isContainerEntity
	ifTrue: [
		entity accesses
			collect: [ :access | access variable ]
			thenSelect: [ :var | var isAttribute ]
	]
	ifFalse: [ #() ]
]'
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultInnerBoxHeight [
	^ 10
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultInnerBoxRange [
	^ #(5 100)
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultInnerBoxScaleType [
	^ #linear
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultInnerBoxSortBlockText [
	^ '[:entityA :entityB :container |
	| sizeA sizeB |
	sizeA := entityA numberOfUsesOn: container.
	sizeB := entityB numberOfUsesOn: container.
	sizeA = sizeB
		ifTrue: [ entityA name < entityB name ]
		ifFalse: [ sizeA > sizeB ]
]'
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultOuterBoxSortBlockText [
	^ '[:containerA :containerB |
"containers are MiCoMethod instances"
| sizeA sizeB |
sizeA := containerA numberOfChildren.
sizeB := containerB numberOfChildren.
sizeA = sizeB
	ifTrue: [ containerA name < containerB name ]
	ifFalse: [ sizeA > sizeB ] ]'
]

{ #category : 'accessing - defaults' }
MiCoUsageMapSettings >> defaultThreshold75 [
	^ 75
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxHeight [
	^ self propertiesMap at: #innerBoxHeight ifAbsent: [ self defaultInnerBoxHeight ].
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxHeight: aNumber [
	self propertiesMap at: #innerBoxHeight put: aNumber
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxRange [
	^ self propertiesMap at: #innerBoxRange ifAbsent: [ self defaultInnerBoxRange ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxRange: anInterval [
	self propertiesMap at: #innerBoxRange put: anInterval
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxScaleType [
	^ self propertiesMap at: #innerBoxScaleType ifAbsent: [ self defaultInnerBoxScaleType ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxScaleType: aString [
	self propertiesMap at: #innerBoxScaleType put: aString
]

{ #category : 'accessing - computed' }
MiCoUsageMapSettings >> innerBoxSortBlockCompiled [
	^ self compiledBlock: self innerBoxSortBlockText onError: self defaultInnerBoxSortBlockText
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxSortBlockText [
	^ self propertiesMap at: #innerBoxSortBlockText ifAbsent: [ self defaultInnerBoxSortBlockText ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> innerBoxSortBlockText: aString [
	self propertiesMap at: #innerBoxSortBlockText put: aString
]

{ #category : 'opening' }
MiCoUsageMapSettings >> openBlocksSettings [
	MiCoUsageMapBlockSettingsPresenter new 
		settings: self;
		open
]

{ #category : 'accessing - computed' }
MiCoUsageMapSettings >> outerBoxSortBlockCompiled [
	^ self compiledBlock: self outerBoxSortBlockText onError: self defaultOuterBoxSortBlockText
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> outerBoxSortBlockText [
	^ self propertiesMap at: #outerBoxSortBlockText ifAbsent: [ self defaultOuterBoxSortBlockText ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> outerBoxSortBlockText: aString [
	self propertiesMap at: #outerBoxSortBlockText put: aString
]

{ #category : 'private' }
MiCoUsageMapSettings >> propertiesMap [
	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : 'class initialization' }
MiCoUsageMapSettings >> reset [
	properties := nil
]

{ #category : 'class initialization' }
MiCoUsageMapSettings >> resetText [
	<script>
	self propertiesMap
		removeKey: #childrenBlockText ifAbsent: [] ;
		removeKey: #outerBoxSortBlockText ifAbsent: [] ;
		removeKey: #innerBoxSortBlockText ifAbsent: [] 
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> scaleTypes [
	^ #(linear symlog)
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> threshold75PercentGroup [
	^ self propertiesMap at: #threshold75 ifAbsent: [ self defaultThreshold75 ]
]

{ #category : 'accessing' }
MiCoUsageMapSettings >> threshold75PercentGroup: aNumber [
	self propertiesMap at: #threshold75 put: aNumber
]
