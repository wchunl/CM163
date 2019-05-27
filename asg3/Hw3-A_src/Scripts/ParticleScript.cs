using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleScript : MonoBehaviour {

    ParticleSystem ps;

    void Start () 
    {
	    // Get Particle system component
		ps = GetComponent<ParticleSystem> ();
        // Call particle play function
		ps.Play();
	}

	void Update () {
    
		int numPartitions = 1;
		float[] aveMag = new float[numPartitions];
		float partitionIndx = 0;
		int numDisplayedBins = 512 / 2; 

		for (int i = 0; i < numDisplayedBins; i++) 
		{
			if(i < numDisplayedBins * (partitionIndx + 1) / numPartitions){
				aveMag[(int)partitionIndx] += AudioPeer.spectrumData [i] / (512/numPartitions);
			}
			else{
				partitionIndx++;
				i--;
			}
		}

		for(int i = 0; i < numPartitions; i++)
		{
			aveMag[i] = (float)0.5 + aveMag[i]*100;
			if (aveMag[i] > 100) {
				aveMag[i] = 100;
			}
		}

		float mag = aveMag[0];
		
		if (mag > 0.8) {
			ps.Emit(1);
		}

	}


}

