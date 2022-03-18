"
I am a special MiBus ensuring communication within all the browsers of a MiWorkspace
I handle MooseEntity communication between the MiWorkspace and the browser(s) it contains and among these browsers.

I am not associated to a Logger
"
Class {
	#name : #MiPrivateBus,
	#superclass : #MiBus,
	#category : #'MooseIDE-Core-Application'
}

{ #category : #initialization }
MiPrivateBus >> initialize [

	super initialize.
	logger := MiPrivateLogger new
]

{ #category : #accessing }
MiPrivateBus >> logger: aPrivateLogger [

	logger := aPrivateLogger
]

{ #category : #actions }
MiPrivateBus >> refreshBrowsersWith: anEntity [

	self browsers do: [ :browser | browser receiveFromPrivateBus: anEntity ]
]
