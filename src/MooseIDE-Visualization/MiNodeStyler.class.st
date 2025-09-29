Class {
	#name : #MiNodeStyler,
	#superclass : #HNodeStyler,
	#category : #'MooseIDE-Visualization-Helpers'
}

{ #category : #accessing }
MiNodeStyler >> iconNamed: anIconName [

	^ [ MiApplication current iconNamed: anIconName ]
		  on: MessageNotUnderstood
		  do: [ MooseIcons mooseCancel ]
]
