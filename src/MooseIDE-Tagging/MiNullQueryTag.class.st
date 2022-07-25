Class {
	#name : #MiNullQueryTag,
	#superclass : #MiQueryTag,
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiNullQueryTag >> category [

	^ nil
]

{ #category : #accessing }
MiNullQueryTag >> color [

	^ nil
]

{ #category : #accessing }
MiNullQueryTag >> description [

	^ nil
]

{ #category : #accessing }
MiNullQueryTag >> isApplicableTo: aQuery [

	^ false
]

{ #category : #accessing }
MiNullQueryTag >> name [
	
	^ 'null dynamic tag'
]

{ #category : #accessing }
MiNullQueryTag >> query [

	^ FQNullQuery new
]