Extension { #name : #RPackage }

{ #category : #'*GToolkit-Coder' }
RPackage >> tags [
	<gtPharoPatch: #Pharo12>
	
	^ self 
		forPharo12AndNewer: [ tags] 
		forPharo11: [ self classTags ]
]
