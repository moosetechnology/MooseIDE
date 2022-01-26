Class {
	#name : #MiNodeStyler,
	#superclass : #HNodeStyler,
	#category : #'MooseIDE-Visualization'
}

{ #category : #accessing }
MiNodeStyler >> iconNamed: anIconName [
	"^super iconNamed: anIconName"
	^[MooseIcons perform: anIconName]
	on: MessageNotUnderstood 
	do: [ MooseIcons mooseCancel ]
]
