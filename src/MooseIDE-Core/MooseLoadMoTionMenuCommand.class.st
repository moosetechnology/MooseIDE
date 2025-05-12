Class {
	#name : #MooseLoadMoTionMenuCommand,
	#superclass : #MooseAbstractLoadToolMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadMoTionMenuCommand class >> help [

	^ 'Load MoTion, a declarative object matching tool.'
]

{ #category : #accessing }
MooseLoadMoTionMenuCommand class >> label [

	^ 'MoTion'
]

{ #category : #'world menu' }
MooseLoadMoTionMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self)
		  withSeparatorAfter;
		  yourself
]

{ #category : #accessing }
MooseLoadMoTionMenuCommand class >> menuPriority [

	^ super menuPriority + 4
]

{ #category : #accessing }
MooseLoadMoTionMenuCommand >> baselineName [

	^ 'MoTion'
]

{ #category : #'as yet unclassified' }
MooseLoadMoTionMenuCommand >> groupToLoad [

	^ 'MoTionMoose'
]

{ #category : #accessing }
MooseLoadMoTionMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/MoTion:' , self version
]

{ #category : #accessing }
MooseLoadMoTionMenuCommand >> version [

	^ 'main'
]
