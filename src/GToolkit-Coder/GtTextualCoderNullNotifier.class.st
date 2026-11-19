"
I am the direct notifier of coders that have nobody to notify directly, such as method coders and the coders of playgrounds, inspectors and debuggers. I notify nobody.
"
Class {
	#name : #GtTextualCoderNullNotifier,
	#superclass : #GtTextualCoderNotifier,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtTextualCoderNullNotifier class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #notifying }
GtTextualCoderNullNotifier >> notifyRenameTemporaryRequested: aGtCoderRenameTemporaryRequestedAnnouncement [
	
]

{ #category : #notifying }
GtTextualCoderNullNotifier >> notifySourceCodeChanged: aGtCoderSourceCodeChanged [
	
]
