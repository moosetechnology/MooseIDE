Class {
	#name : #MiNullDynamicTag,
	#superclass : #MiDynamicTag,
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #accessing }
MiNullDynamicTag >> color [

	^ Color gray
]

{ #category : #accessing }
MiNullDynamicTag >> name [

	^ ''
]

{ #category : #accessing }
MiNullDynamicTag >> query [

	^ [ :e | false ]
]
