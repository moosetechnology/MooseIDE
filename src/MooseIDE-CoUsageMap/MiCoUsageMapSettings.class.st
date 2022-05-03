"
I am a singleton, I store global values for settings used by CoUsageMapBuilder
"
Class {
	#name : #MiCoUsageMapSettings,
	#superclass : #Object,
	#classInstVars : [
		'properties'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #settings }
MiCoUsageMapSettings class >> browsingBlockSettings: aBuilder [
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

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingInnerBoxRange: aBuilder [
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

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingInnerScale: aBuilder [
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

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingInnerSize: aBuilder [
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

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingThreshold: aBuilder [
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

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettings01On: aBuilder [
	<systemsettings>
	(aBuilder group: #moose)
		label: 'Moose';
		description: 'All settings concerned with moose browsers'
]

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettings02On: aBuilder [
	<systemsettings>
	(aBuilder group: #CoUsageMap)
		parent: #moose;
		label: 'Co Usage Map';
		description: 'Alls settings concerned with co usage map browser'
]

{ #category : #accessing }
MiCoUsageMapSettings class >> buttonSettingLabel [
	^ 'Blocks Settings'
		

]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> childrenBlockCompiled [
	^ self compiledBlock: self childrenBlockText onError: self defaultChildrenBlockText
]

{ #category : #accessing }
MiCoUsageMapSettings class >> childrenBlockText [
	^ self propertiesMap at: #childrenBlockText ifAbsent: [ self defaultChildrenBlockText ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> childrenBlockText: aString [
	self propertiesMap at: #childrenBlockText put: aString
]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> compiledBlock: aString onError: defaultString [
	| compiler |
	compiler := Smalltalk compiler.
	^ [ compiler evaluate: aString ]
	on: Error
	do: [ :ex | compiler evaluate: defaultString ]
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultChildrenBlockText [
	^ '[ :entity |
"this code is for entity method, but you can change it"
"you should return all the inner entities even with duplicates"

entity accesses 
	select: [ :slotLink | slotLink variable isAttribute ]
	thenCollect: [ :slotLink | slotLink variable ]
]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxHeight [
	^ 10
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxRange [
	^ #(5 100)
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxScaleType [
	^ #linear
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxSortBlockText [
	^ '[:entityA :entityB :container |
	| sizeA sizeB |
	sizeA := entityA numberOfUsesOn: container.
	sizeB := entityB numberOfUsesOn: container.
	sizeA = sizeB
		ifTrue: [ entityA name < entityB name ]
		ifFalse: [ sizeA > sizeB ]
]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultOuterBoxSortBlockText [
	^ '[:containerA :containerB |
"containers are MiCoMethod instances"
| sizeA sizeB |
sizeA := containerA numberOfChildren.
sizeB := containerB numberOfChildren.
sizeA = sizeB
	ifTrue: [ containerA name < containerB name ]
	ifFalse: [ sizeA > sizeB ] ]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultThreshold75 [
	^ 75
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxHeight [
	^ self propertiesMap at: #innerBoxHeight ifAbsent: [ self defaultInnerBoxHeight ].
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxHeight: aNumber [
	self propertiesMap at: #innerBoxHeight put: aNumber
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxRange [
	^ self propertiesMap at: #innerBoxRange ifAbsent: [ self defaultInnerBoxRange ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxRange: anInterval [
	self propertiesMap at: #innerBoxRange put: anInterval
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxScaleType [
	^ self propertiesMap at: #innerBoxScaleType ifAbsent: [ self defaultInnerBoxScaleType ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxScaleType: aString [
	self propertiesMap at: #innerBoxScaleType put: aString
]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> innerBoxSortBlockCompiled [
	^ self compiledBlock: self innerBoxSortBlockText onError: self defaultInnerBoxSortBlockText
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSortBlockText [
	^ self propertiesMap at: #innerBoxSortBlockText ifAbsent: [ self defaultInnerBoxSortBlockText ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSortBlockText: aString [
	self propertiesMap at: #innerBoxSortBlockText put: aString
]

{ #category : #opening }
MiCoUsageMapSettings class >> openBlocksSettings [
	MiCoUsageMapBlockSettingsPresenter new 
		settings: self;
		open
]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> outerBoxSortBlockCompiled [
	^ self compiledBlock: self outerBoxSortBlockText onError: self defaultOuterBoxSortBlockText
]

{ #category : #accessing }
MiCoUsageMapSettings class >> outerBoxSortBlockText [
	^ self propertiesMap at: #outerBoxSortBlockText ifAbsent: [ self defaultOuterBoxSortBlockText ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> outerBoxSortBlockText: aString [
	self propertiesMap at: #outerBoxSortBlockText put: aString
]

{ #category : #private }
MiCoUsageMapSettings class >> propertiesMap [
	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : #'class initialization' }
MiCoUsageMapSettings class >> reset [
	<script>
	properties := nil
]

{ #category : #'class initialization' }
MiCoUsageMapSettings class >> resetText [
	<script>
	self propertiesMap
		removeKey: #childrenBlockText;
		removeKey: #outerBoxSortBlockText;
		removeKey: #innerBoxSortBlockText
]

{ #category : #accessing }
MiCoUsageMapSettings class >> scaleTypes [
	^ #(linear symlog)
]

{ #category : #accessing }
MiCoUsageMapSettings class >> threshold75PercentGroup [
	^ self propertiesMap at: #threshold75 ifAbsent: [ self defaultThreshold75 ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> threshold75PercentGroup: aNumber [
	self propertiesMap at: #threshold75 put: aNumber
]
