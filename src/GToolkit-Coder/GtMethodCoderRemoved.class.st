Class {
	#name : #GtMethodCoderRemoved,
	#superclass : #GtCoderMethodAnnouncement,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtMethodCoderRemoved >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtMethodCoderRemoved >> methodCoder: aMethodCoder [
	methodCoder := aMethodCoder
]
