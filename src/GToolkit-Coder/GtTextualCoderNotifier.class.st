"
A {{gtClass:GtTextualCoder}} notifies through me, by direct message sends, before it announces to the subscribers of its announcer.
I am held strongly by the coder. Use me when the object to notify is known and lives as long as the coder, so that it does not need a (weak) subscription on the coder's announcer.
Coders that have nobody to notify directly use {{gtClass:GtTextualCoderNullNotifier}}.
"
Class {
	#name : #GtTextualCoderNotifier,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #notifying }
GtTextualCoderNotifier >> notifyRenameTemporaryRequested: aGtCoderRenameTemporaryRequestedAnnouncement [
	^ self subclassResponsibility
]

{ #category : #notifying }
GtTextualCoderNotifier >> notifySourceCodeChanged: aGtCoderSourceCodeChanged [
	^ self subclassResponsibility
]
