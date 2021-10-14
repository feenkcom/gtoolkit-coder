Class {
	#name : #GtCoderRenameTemporaryRequestedAnnouncement,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'variableName',
		'interestedCoders'
	],
	#category : 'GToolkit-Coder-Event'
}

{ #category : #initialization }
GtCoderRenameTemporaryRequestedAnnouncement >> initialize [
	super initialize.
	interestedCoders := OrderedCollection new
]

{ #category : #accessing }
GtCoderRenameTemporaryRequestedAnnouncement >> interestedCoders [
	^ interestedCoders
]

{ #category : #accessing }
GtCoderRenameTemporaryRequestedAnnouncement >> variableName [
	^ variableName
]

{ #category : #accessing }
GtCoderRenameTemporaryRequestedAnnouncement >> variableName: aString [
	variableName := aString
]
