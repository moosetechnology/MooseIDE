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
	^ SpBoxLayout newHorizontal
		add: #fameExtension;
		yourself
]

{ #category : #specs }
MiFameBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Fame)
		parent: self toolbarName;
		label: 'Fame browser';
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
MiFameBrowser >> initializePresenters [
	fameExtension := MiFameExtension on: MooseModel new
]

{ #category : #initialization }
MiFameBrowser >> selectEntity: anEntity [
	(self accept: anEntity)
		ifFalse: [ ^ self ].
	fameExtension model: anEntity.
]

{ #category : #initialization }
MiFameBrowser >> title [
	^ 'Fame Browser'
]
