Class {
	#name : 'MiShowAllLinksCommand',
	#superclass : 'MiShapeInBrowserCommand',
	#category : 'MooseIDE-Visualization-Commands',
	#package : 'MooseIDE-Visualization',
	#tag : 'Commands'
}

{ #category : 'default' }
MiShowAllLinksCommand class >> defaultDescription [

	^'Show all links related to an entity that were previously hidden'
]

{ #category : 'default' }
MiShowAllLinksCommand class >> defaultName [

	^'Show links'
]

{ #category : 'executing' }
MiShowAllLinksCommand >> execute [

	browser showAllLinks: context
]
