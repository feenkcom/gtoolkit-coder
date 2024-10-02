Class {
	#name : #GtCoderNavigationProtocolSelected,
	#superclass : #GtCoderNavigationSelectionAnnouncement,
	#instVars : [
		'protocol'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationProtocolSelected >> protocol [
	^ protocol
]

{ #category : #accessing }
GtCoderNavigationProtocolSelected >> protocol: anObject [
	protocol := anObject
]
