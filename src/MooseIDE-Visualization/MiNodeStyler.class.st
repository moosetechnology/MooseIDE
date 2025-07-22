Class {
	#name : 'MiNodeStyler',
	#superclass : 'HNodeStyler',
	#category : 'MooseIDE-Visualization-Helpers',
	#package : 'MooseIDE-Visualization',
	#tag : 'Helpers'
}

{ #category : 'accessing' }
MiNodeStyler >> iconNamed: anIconName [
	"^super iconNamed: anIconName"
	^[MooseIcons perform: anIconName]
	on: MessageNotUnderstood 
	do: [ MooseIcons mooseCancel ]
]
