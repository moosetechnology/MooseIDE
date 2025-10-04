"
An entry in the context menu of Hierarchical visualizations that allows to redisplay entities with their (new) tags
"
Class {
	#name : 'HUpdateTagsMenuItem',
	#superclass : 'HCanvasMenuItem',
	#category : 'MooseIDE-API-Browser-menus',
	#package : 'MooseIDE-API-Browser',
	#tag : 'menus'
}

{ #category : 'execution' }
HUpdateTagsMenuItem >> execute [
	visualization updateTags
	
]

{ #category : 'accessing' }
HUpdateTagsMenuItem >> label [
	^ 'Update tags'
]

{ #category : 'accessing' }
HUpdateTagsMenuItem >> order [
	^ 65
]
