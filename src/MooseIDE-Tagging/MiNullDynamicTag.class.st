Class {
	#name : #MiNullDynamicTag,
	#superclass : #MiDynamicTag,
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiNullDynamicTag >> category [

	^ nil
]

{ #category : #accessing }
MiNullDynamicTag >> color [

	^ Color gray
]

{ #category : #accessing }
MiNullDynamicTag >> description [

	^ nil
]

{ #category : #accessing }
MiNullDynamicTag >> isApplicableTo: aQuery [

	^ false
]

{ #category : #accessing }
MiNullDynamicTag >> name [
	
	^ 'null dynamic tag'
]

{ #category : #accessing }
MiNullDynamicTag >> query [

	^ FQNullQuery new
]
