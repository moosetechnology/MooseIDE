Extension { #name : #MiBusLogBrowser }

{ #category : #'*MooseIDE-Tests' }
MiBusLogBrowser >> localActionButtons [

	^ self localToolbarCommandGroup commands collect: #presenter
]
