"
A small tool to conveniently gather a set of entities

Just propagate entities to it from any other tool and when you are done, propagate all the entities it gathered
"
Class {
	#name : #MiAccumulatorBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'btnClear',
		'statusBar',
		'lstEntities',
		'btnRemove'
	],
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #'world menu' }
MiAccumulatorBrowser class >> menuItem [

	^#AccumulatorBrowser
]

{ #category : #'instance creation' }
MiAccumulatorBrowser class >> newModel [

	^ MiAccumulatorBrowserModel new
]

{ #category : #'instance creation' }
MiAccumulatorBrowser class >> open [
	<script>
	^ super open
]

{ #category : #'world menu' }
MiAccumulatorBrowser class >> title [
	^ 'Accumulator Browser'
]

{ #category : #'private - testing' }
MiAccumulatorBrowser >> btnClear [

	^btnClear
]

{ #category : #'private - testing' }
MiAccumulatorBrowser >> btnRemove [

	^btnRemove
]

{ #category : #testing }
MiAccumulatorBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #actions }
MiAccumulatorBrowser >> followEntity: anObject [

	specModel newEntities: anObject
]

{ #category : #initialization }
MiAccumulatorBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: lstEntities expand: true ;
		add: (SpBoxLayout newLeftToRight
				add: btnRemove expand: false ;
				add: btnClear expand: false ;
				yourself)
		expand: false ;
		add: statusBar expand: false ;
		yourself)
]

{ #category : #initialization }
MiAccumulatorBrowser >> initializeListEntities [

	lstEntities := self newFilteringList.
	lstEntities listPresenter beMultipleSelection.
	lstEntities display: [ :entity | entity name ].

	lstEntities whenSelectionChangedDo: [ :selection | 
		specModel selectedEntities: selection selectedItems ]
]

{ #category : #initialization }
MiAccumulatorBrowser >> initializePresenters [

	super initializePresenters.

	self initializeListEntities.

	btnRemove := self newButton
		label: 'Remove';
		action: [ specModel removeSelectedEntities ].
	btnClear := self newButton
		label: 'Clear';
		action: [ specModel clearEntities ].

	statusBar := self newLabel.
	self updateStatusBar.

	self initializeLayout
]

{ #category : #accessing }
MiAccumulatorBrowser >> miSelectedItem [

	^specModel selectedEntities ifEmpty: [ specModel entities ]
]

{ #category : #utilities }
MiAccumulatorBrowser >> updateEntityList: entities [

	lstEntities items: entities.

	self updateStatusBar 
]

{ #category : #utilities }
MiAccumulatorBrowser >> updateStatusBar [

	^String streamContents: [ :stream |
		stream
			<< 'Entity list: ' ;
			<< specModel numberOfEntities asString ;
			<< ' | Selected entities: ' ;
			<< specModel numberOfSelectedEntities asString.
		statusBar label: stream contents
	]
]
