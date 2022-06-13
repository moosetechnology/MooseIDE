Class {
	#name : #MiDMBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #accessing }
MiDMBrowser class >> mapClass [

	^ MiDM
]

{ #category : #'world menu' }
MiDMBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^(aBuilder item: #DMBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		help: self helpMessage;
		order: self menuPriority;
		action: [ self open ] ;
		yourself
]

{ #category : #menu }
MiDMBrowser class >> menuPriority [

	^ 5
]

{ #category : #'instance creation' }
MiDMBrowser class >> newModel [

	^ MiDistributionMapModel new
]

{ #category : #accessing }
MiDMBrowser class >> open [
	<script>
	super open
]

{ #category : #accessing }
MiDMBrowser class >> title [

	^ 'Distribution map'
]

{ #category : #accessing }
MiDMBrowser class >> windowSize [

	^ 850 @ 520
]

{ #category : #adding }
MiDMBrowser >> addDynamicTags: aCollection [

	aCollection do: [ :dt | self model addDynamicTag: dt ].
	"settings refreshTagList"
]

{ #category : #actions }
MiDMBrowser >> availableQueries [

	^ (self application itemsFor: FQAbstractQuery) asOrderedCollection 
		  select: [ :q | q isValid ]
]

{ #category : #initialization }
MiDMBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: self
]

{ #category : #actions }
MiDMBrowser >> canFollowEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #testing }
MiDMBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #initialization }
MiDMBrowser >> canvas [

	^ visualization canvas
]

{ #category : #actions }
MiDMBrowser >> followEntity: anEntity [

	model entities: anEntity asMooseGroup.
	self runVisualization
]

{ #category : #testing }
MiDMBrowser >> hasSettings [

	^ true
]

{ #category : #initialization }
MiDMBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 3;
			 add: visualization;
			 yourself)
]

{ #category : #initialization }
MiDMBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	self initializeLayout
]

{ #category : #accessing }
MiDMBrowser >> miSelectedItem [

	^ model entities mooseInterestingEntity
]

{ #category : #actions }
MiDMBrowser >> runVisualization [

	visualization run
]

{ #category : #accessing }
MiDMBrowser >> settings [

	model settings open
]

{ #category : #initialization }
MiDMBrowser >> visualization [

	^ visualization
]
