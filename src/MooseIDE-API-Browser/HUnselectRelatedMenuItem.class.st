"
An entry in selected entities context menu of Hierarchical visualizations that un-selects all nodes related to the current entity (under the mouse)
"
Class {
	#name : 'HUnselectRelatedMenuItem',
	#superclass : 'HGroupMenuItem',
	#category : 'MooseIDE-API-Browser-menus',
	#package : 'MooseIDE-API-Browser',
	#tag : 'menus'
}

{ #category : 'execution' }
HUnselectRelatedMenuItem >> execute [

	visualization mapModel unselectRelatedTo: shape model rawModel
]

{ #category : 'accessing' }
HUnselectRelatedMenuItem >> group [

	^ 3
]

{ #category : 'accessing' }
HUnselectRelatedMenuItem >> label [

	^ 'Un-select related entities'
]

{ #category : 'accessing' }
HUnselectRelatedMenuItem >> order [

	^80
]
