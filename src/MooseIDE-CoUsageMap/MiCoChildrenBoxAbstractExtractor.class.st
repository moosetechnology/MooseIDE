"
An abstract super-class for various strategies to compute children boxes of a container box
"
Class {
	#name : 'MiCoChildrenBoxAbstractExtractor',
	#superclass : 'Object',
	#category : 'MooseIDE-CoUsageMap-Model',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiCoChildrenBoxAbstractExtractor class >> description [

	self subclassResponsibility 
]

{ #category : 'accessing' }
MiCoChildrenBoxAbstractExtractor class >> menuItemName [

	self subclassResponsibility 
]

{ #category : 'execute' }
MiCoChildrenBoxAbstractExtractor >> innerBoxesFor: containerBox [

	self subclassResponsibility 
]

{ #category : 'accessing' }
MiCoChildrenBoxAbstractExtractor >> name [

	self subclassResponsibility 
]
