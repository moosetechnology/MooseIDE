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

{ #category : #'accessing - private tests' }
MiFullWorkspace >> at: anInteger putBrowser: aMiBrowser [
	"only use for tests !"
	| containerMap |
	containerMap := {  1 -> left . 2 -> middle . 3 -> right . 4 -> downLeft . 5 -> downMiddle . 6 -> downRight }
	asDictionary.
	self install: aMiBrowser inContainer: (containerMap at: anInteger)
]

{ #category : #testing }
MiFullWorkspace >> canReceiveEntity: anObject [
	"accepts all entities, the children browsers will decide for themselves if they accept or not"
	^true
]

{ #category : #accessing }
MiFullWorkspace >> containedBrowsers [
	^{left . middle . right . downRight . downMiddle . downLeft}
	select: [ :browserContainer | browserContainer installedPresenter notNil ]
	thenCollect: [ :browserContainer | browserContainer installedPresenter ]
]

{ #category : #'private - updating' }
MiFullWorkspace >> desiredWindowSize [
	^self class windowSize
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
		   self shouldAcceptTransfer: transfer into: destination ];"
	   acceptDrop: [ :transfer :destination | 
		   "self installTransfer: transfer into: destination"
			self install: transfer passenger inContainer: destination owner ] ;
		yourself
]

{ #category : #removing }
MiFullWorkspace >> noteThatWidgetHasBeenReinstalled: aMiBrowser [

]

{ #category : #initialization }
MiFullWorkspace >> windowTitle [
	^self class title
]
