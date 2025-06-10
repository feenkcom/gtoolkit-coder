Extension { #name : #RPackage }

{ #category : #'*GToolkit-Coder' }
RPackage >> tags [
	<gtPharoPatch: #Pharo12>
	
	^ self 
		forPharo12: [ tags] 
		forPharo11AndPharo10: [ self classTags ]
]
