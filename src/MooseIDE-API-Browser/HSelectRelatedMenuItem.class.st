"
An entry in entities context menu of Hierarchical visualizations that selects all nodes related to the current one
"
Class {
	#name : 'HSelectRelatedMenuItem',
	#superclass : 'HNodeMenuItem',
	#category : 'MooseIDE-API-Browser-menus',
	#package : 'MooseIDE-API-Browser',
	#tag : 'menus'
}

{ #category : 'execution' }
HSelectRelatedMenuItem >> execute [

	visualization mapModel selectRelatedTo: shape model rawModel
]

{ #category : 'accessing' }
HSelectRelatedMenuItem >> group [

	^ 3
]

{ #category : 'accessing' }
HSelectRelatedMenuItem >> label [

	^ 'Select related entities'
]

{ #category : 'accessing' }
HSelectRelatedMenuItem >> order [

	^85
]
