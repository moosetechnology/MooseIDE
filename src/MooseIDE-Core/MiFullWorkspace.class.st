"
I am a workspace that can contain several browsers
"
Class {
	#name : #MiFullWorkspace,
	#superclass : #MiAbstractWorkspace,
	#instVars : [
		'containerLine1',
		'containerLine2'
	],
	#category : #'MooseIDE-Core-Browser'
}

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
	<script: 'MifullWorkspace open'>
	^super open
]

{ #category : #accessing }
MiFullWorkspace class >> title [
	^'MooseIDE workspace'
]

{ #category : #specs }
MiFullWorkspace class >> windowSize [
	^ 1000 @ 500
]

{ #category : #'private - updating' }
MiFullWorkspace >> desiredWindowSize [
	^self class windowSize
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
