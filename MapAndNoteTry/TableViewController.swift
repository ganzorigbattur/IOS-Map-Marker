//
//  TableViewController.swift
//  MapAndNoteTry
//
//  Created by Ganzorig Battur on 9/15/17.
//  Copyright © 2017 Ganzorig Battur. All rights reserved.
//

import UIKit

var notes = [Dictionary<String,String>()]
var noteTracker = -1

class TableViewController: UITableViewController {

    @IBOutlet var table: UITableView!

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let tempPlaces = UserDefaults.standard.object(forKey: "notes") as? [Dictionary<String,String>] {
        
            notes = tempPlaces
        
        }
        if notes.count == 1 && notes[0].count == 0 {
            
            notes.remove(at: 0)
            
            notes.append(["place":"Minneapolis", "note":"Super Nice Place to Live","latit":"44.976384","longit":"-93.251960"])
            UserDefaults.standard.set(notes, forKey:"notes")
        }
        noteTracker = -1
        table.reloadData()
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexpath: IndexPath){
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            notes.remove(at: indexpath.row)
            table.reloadData()
            UserDefaults.standard.set(notes, forKey:"notes")
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }

    // set up cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        if notes[indexPath.row]["place"] != nil {
        
        cell.textLabel?.text = notes[indexPath.row]["place"]}

        return cell
    }
    

    
    // segue happen when hit a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteTracker = indexPath.row
        performSegue(withIdentifier: "toNoteAndMap", sender: nil)
        
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
