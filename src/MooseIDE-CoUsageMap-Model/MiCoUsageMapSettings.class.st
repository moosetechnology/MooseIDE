"
TODO
"
Class {
	#name : #MiCoUsageMapSettings,
	#superclass : #Object,
	#classInstVars : [
		'innerBoxSize',
		'threshold75',
		'childrenBlock',
		'outerBoxSortBlock',
		'innerBoxSortBlock'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #private }
MiCoUsageMapSettings class >> browserDo: aBlock [
	Smalltalk globals 
		at: #MiCoUsageMapMooseBuilder
		ifPresent: [ :cls | cls allInstancesDo: aBlock ]
		ifAbsent: [ "nothing" ]
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
MiCoUsageMapSettings class >> childrenBlock [
	^ childrenBlock ifNil: [ self defaultChildrenBlock ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> childrenBlock: aBlock [
	childrenBlock := aBlock
]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> childrenBlockCompiled [
	^ self compiledBlock: self childrenBlock onError: self defaultChildrenBlock
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
MiCoUsageMapSettings class >> defaultChildrenBlock [
	^ '[:node | #() ]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxSize [
	^ 5
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxSortBlock [
	^ '[:a :b | a name < b name ]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultOuterBoxSortBlock [
	^ '[:a :b |
| s1 s2| 
s1 := a usedAttributes size.
s2 := b usedAttributes size.
s1 = s2
	ifTrue: [a name < b name ]
	ifFalse: [ s1 > s2] ]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultThreshold75 [
	^ 75
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSize [
	^ innerBoxSize ifNil: [ self defaultInnerBoxSize ].
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSize: aNumber [
	innerBoxSize := aNumber.
	self browserDo: [ :b | b innerBoxSize: aNumber ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSortBlock [
	^ innerBoxSortBlock ifNil: [ self defaultInnerBoxSortBlock ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSortBlock: aBlock [
	innerBoxSortBlock := aBlock
]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> innerBoxSortBlockCompiled [
	^ self compiledBlock: self innerBoxSortBlock onError: self defaultInnerBoxSortBlock
]

{ #category : #accessing }
MiCoUsageMapSettings class >> outerBoxSortBlock [
	^ outerBoxSortBlock ifNil: [ self defaultOuterBoxSortBlock ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> outerBoxSortBlock: aBlock [
	outerBoxSortBlock := aBlock
]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> outerBoxSortBlockCompiled [
	^ self compiledBlock: self outerBoxSortBlock onError: self defaultOuterBoxSortBlock
]

{ #category : #initialization }
MiCoUsageMapSettings class >> reset [
	<script>
	innerBoxSize := threshold75 := childrenBlock := outerBoxSortBlock := innerBoxSortBlock := nil
]

{ #category : #accessing }
MiCoUsageMapSettings class >> threshold75PercentGroup [
	^ threshold75 ifNil: [ self defaultThreshold75 ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> threshold75PercentGroup: aNumber [
	threshold75 := aNumber.
	self browserDo: [ :b | b threshold75: threshold75 ]
]
