Class {
	#name : 'MiHideAllLinksCommand',
	#superclass : 'MiShapeInBrowserCommand',
	#category : 'MooseIDE-Visualization-Commands',
	#package : 'MooseIDE-Visualization',
	#tag : 'Commands'
}

{ #category : 'default' }
MiHideAllLinksCommand class >> defaultDescription [

	^'Hide all incoming and outgoing links related to a displayed entity in Roassal'
]

{ #category : 'default' }
MiHideAllLinksCommand class >> defaultName [

	^'Hide links'
]

{ #category : 'executing' }
MiHideAllLinksCommand >> execute [

	browser hideAllLinks: context
]
