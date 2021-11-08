"
I am a workspace that can contain several browsers
"
Class {
	#name : #MiFullWorkspace,
	#superclass : #MiAbstractWorkspace,
	#instVars : [
		'left',
		'middle',
		'right',
		'downRight',
		'downMiddle',
		'downLeft'
	],
	#category : #'MooseIDE-Core-workspace'
}

{ #category : #specs }
MiFullWorkspace class >> defaultSpec [
	| myLayout |
	myLayout := SpBoxLayout newTopToBottom.
	myLayout
		  add: (SpPanedLayout newTopToBottom
					positionOfSlider: 95 percent ;
				   add: (SpPanedLayout newLeftToRight
							positionOfSlider: 95 percent ;
						    add: (SpPanedLayout newLeftToRight
										add: #left;
										add: #middle;
										yourself);
						    add: #right;
						    yourself);
				   add: (SpPanedLayout newLeftToRight
						    add: (SpPanedLayout newLeftToRight
								     add: #downLeft;
								     add: #downMiddle;
										yourself);
						    add: #downRight;
						    yourself);
					yourself).

		^myLayout
]

{ #category : #'world menu' }
MiFullWorkspace class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: self midasBrowserMenuLabel)
		order: 5;
		parent: #Moose;
		icon: MooseIcons mooseIcon
]

{ #category : #'world menu' }
MiFullWorkspace class >> midasBrowserMenuLabel [
	^'Workspace'
]

{ #category : #'instance creation' }
MiFullWorkspace class >> open [
	<script: 'MiFullWorkspace open'>
	^super open
]

{ #category : #accessing }
MiFullWorkspace class >> title [
	^'MooseIDE workspace'
]

{ #category : #specs }
MiFullWorkspace class >> windowSize [
	^ 1400 @ 600
]

{ #category : #testing }
MiFullWorkspace >> canFollow [

	^true
]

{ #category : #testing }
MiFullWorkspace >> canReceiveEntity: anObject [
	"accepts all entities, the children browsers will decide for themselves if they accept or not"
	^true
]

{ #category : #'private - updating' }
MiFullWorkspace >> desiredWindowSize [
	^self class windowSize
]

{ #category : #actions }
MiFullWorkspace >> followEntity: anEntity [
    self freezeDuring: [privateBus globallySelect: anEntity]
]

{ #category : #initialization }
MiFullWorkspace >> initializePresenters [

	super initializePresenters.

	left := self newContainer.
	middle := self newContainer.
	right := self newContainer.
	downRight := self newContainer.
	downMiddle := self newContainer.
	downLeft := self newContainer
]

{ #category : #initialization }
MiFullWorkspace >> newContainer [
	^super newContainer
	   borderWidth: 2;
	   "dropEnabled: true;
	   wantsDrop: [ :transfer :destination | 
		   self shouldAcceptTransfer: transfer into: destination ];
	   acceptDrop: [ :transfer :destination | 
		   self installTransfer: transfer into: destination ] ;"
		yourself
]

{ #category : #'private - updating' }
MiFullWorkspace >> updateTitle [
	self hasWindow
		ifTrue: [ self window title: self windowTitle]

]

{ #category : #'private - updating' }
MiFullWorkspace >> updateWindowSize [
	^self desiredWindowSize

]

{ #category : #initialization }
MiFullWorkspace >> windowTitle [
	^self class title
]
