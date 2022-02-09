"
TODO
"
Class {
	#name : #MiCoUsageMapSettings,
	#superclass : #Object,
	#classInstVars : [
		'innerBoxSize',
		'threshold75',
		'childrenBlockText',
		'outerBoxSortBlockText',
		'innerBoxSortBlockText'
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

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> childrenBlockCompiled [
	^ self compiledBlock: self childrenBlockText onError: self defaultChildrenBlockText
]

{ #category : #accessing }
MiCoUsageMapSettings class >> childrenBlockText [
	^ childrenBlockText ifNil: [ self defaultChildrenBlockText ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> childrenBlockText: aString [
	childrenBlockText := aString
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
	^ '[:node | #() ]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxSize [
	^ 5
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxSortBlockText [
	^ '[:a :b | a name < b name ]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultOuterBoxSortBlockText [
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

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> innerBoxSortBlockCompiled [
	^ self compiledBlock: self innerBoxSortBlockText onError: self defaultInnerBoxSortBlockText
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSortBlockText [
	^ innerBoxSortBlockText ifNil: [ self defaultInnerBoxSortBlockText ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSortBlockText: aString [
	innerBoxSortBlockText := aString.
	self browserDo: [ :b | b updateShapeLayout ]
]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> outerBoxSortBlockCompiled [
	^ self compiledBlock: self outerBoxSortBlockText onError: self defaultOuterBoxSortBlockText
]

{ #category : #accessing }
MiCoUsageMapSettings class >> outerBoxSortBlockText [
	^ outerBoxSortBlockText ifNil: [ self defaultOuterBoxSortBlockText ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> outerBoxSortBlockText: aString [
	outerBoxSortBlockText := aString.
	self browserDo: [ :b | b updateShapeLayout ]
]

{ #category : #initialization }
MiCoUsageMapSettings class >> reset [
	<script>
	innerBoxSize := threshold75 := childrenBlockText := outerBoxSortBlockText := innerBoxSortBlockText := nil
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
