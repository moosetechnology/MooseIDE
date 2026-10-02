Class {
	#name : 'MiNullDynamicTag',
	#superclass : 'MiDynamicTag',
	#category : 'MooseIDE-Tagging-Model',
	#package : 'MooseIDE-Tagging',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiNullDynamicTag >> category [

	^ nil
]

{ #category : 'accessing' }
MiNullDynamicTag >> color [

	^ nil
]

{ #category : 'accessing' }
MiNullDynamicTag >> description [

	^ nil
]

{ #category : 'accessing' }
MiNullDynamicTag >> isApplicableTo: aQuery [

	^ false
]

{ #category : 'accessing' }
MiNullDynamicTag >> name [
	
	^ 'null dynamic tag'
]

{ #category : 'accessing' }
MiNullDynamicTag >> query [

	^ FQNullQuery new
]
