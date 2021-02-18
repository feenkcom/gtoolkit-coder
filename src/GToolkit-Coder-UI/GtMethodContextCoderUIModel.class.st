Class {
	#name : #GtMethodContextCoderUIModel,
	#superclass : #GtMethodCoderUIModel,
	#category : #'GToolkit-Coder-UI-Coder - Method Model'
}

{ #category : #notifications }
GtMethodContextCoderUIModel >> notifyContextPCRangeChangedTo: anInterval [
	self announcerUIModel
		announce: (GtMethodCoderContextPCRangeChanged new
			pcRange: anInterval)
]

{ #category : #accessing }
GtMethodContextCoderUIModel >> programCounterRange [
	^ self coder 
		ifNotNil: [ :aCoder | aCoder programCounterRange ]
]

{ #category : #updating }
GtMethodContextCoderUIModel >> updateProgramCounterRange [
	self notifyContextPCRangeChangedTo: self programCounterRange
]
