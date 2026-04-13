Extension { #name : 'MiAbstractBrowser' }

{ #category : '*MooseIDE-Tests' }
MiAbstractBrowser >> actionButtons [

	^ (self toolbarCommandGroup commandOrGroupNamed: 'Actions') commands
		  collect: #presenter
]

{ #category : '*MooseIDE-Tests' }
MiAbstractBrowser >> busButton [

	^ (self toolbarCommandGroup commandOrGroupNamed: 'Buses') presenter
]

{ #category : '*MooseIDE-Tests' }
MiAbstractBrowser class >> openForTests: aTestApplication [

	^ (self newApplication: aTestApplication model: self newModel)
		  open;
		  followBus: aTestApplication defaultBus;
		  yourself
]

{ #category : '*MooseIDE-Tests' }
MiAbstractBrowser >> privateReceivingMode: aMiBrowserReceivingMode [

	"DO NOT USE ME, I AM FOR TESTS"

	receivingMode := aMiBrowserReceivingMode
]

{ #category : '*MooseIDE-Tests' }
MiAbstractBrowser >> toolbarButton: aLabel [

	^ (self toolbarCommandGroup allCommands collect: #presenter) detect: [
		  :button | button label = aLabel ]
]
