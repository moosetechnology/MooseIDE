Class {
	#name : #MiFameBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'fameExtension'
	],
	#category : #'Midas-FameBrowser'
}

{ #category : #specs }
MiFameBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #fameExtension;
		yourself
]

{ #category : #specs }
MiFameBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Fame)
		parent: self toolbarMetaName;
		label: 'Fame browser';
		icon: (self iconNamed: #mooseFame);
		order: 4.0;
		action: [ self runMe ]
]

{ #category : #specs }
MiFameBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #initialization }
MiFameBrowser >> accept: anObject [
	^ anObject isKindOf: MooseEntity 
]

{ #category : #initialization }
MiFameBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	fameExtension model: toSelect
]

{ #category : #initialization }
MiFameBrowser >> initializePresenters [
	super initializePresenters.
	fameExtension := MiFameExtension on: MooseGroup new
]

{ #category : #initialization }
MiFameBrowser >> title [
	^ 'Fame Browser'
]
