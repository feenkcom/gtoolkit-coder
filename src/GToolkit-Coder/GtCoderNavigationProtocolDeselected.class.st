Class {
	#name : #GtCoderNavigationProtocolDeselected,
	#superclass : #GtCoderNavigationSelectionAnnouncement,
	#instVars : [
		'protocol'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationProtocolDeselected >> protocol [
	^ protocol
]

{ #category : #accessing }
GtCoderNavigationProtocolDeselected >> protocol: anObject [
	protocol := anObject
]
