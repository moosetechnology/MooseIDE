Class {
	#name : #MiHollowLogger,
	#superclass : #MiLogger,
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #'as yet unclassified' }
MiHollowLogger >> activateNewLogFor: anEntity in: aBus [

	| newLogger |
	newLogger := MiPrivateLogger new.
	aBus logger: newLogger.

	^ newLogger activateNewLogFor: anEntity in: aBus
]

{ #category : #accessing }
MiHollowLogger >> mostRecentLog [

	MiDesynchronizedPrivateBusException signal
]
